{
  description = "lianas.org";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    hugoFor = pkgs:
      pkgs.hugo.overrideAttrs (_final: _prev: rec {
        version = "0.163.3";

        src = pkgs.fetchFromGitHub {
          owner = "gohugoio";
          repo = "hugo";
          tag = "v${version}";
          hash = "sha256-o8MoGrdOXBN/HkcuRsHyyyFLvPvNo3PI0oWBlO6Xfpw=";
        };

        vendorHash = "sha256-Bn+RA+EHd3gAKL4N/ibydX7yWNKOSYnIl2pfecfOu1k=";
      });
  in {
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        hugo = hugoFor pkgs;

        src = pkgs.lib.fileset.toSource {
          root = ./.;
          fileset = pkgs.lib.fileset.unions [
            ./archetypes
            ./content
            ./data
            ./go.mod
            ./go.sum
            ./hugo.toml
            ./layouts
            ./static
          ];
        };

        modules = pkgs.stdenvNoCC.mkDerivation {
          name = "blog-hugo-modules";
          inherit src;

          nativeBuildInputs = [hugo] ++ (with pkgs; [cacert git go]);

          buildPhase = ''
            export HOME=$NIX_BUILD_TOP
            hugo mod vendor
          '';

          installPhase = "mv _vendor $out";

          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
          outputHash = "sha256-mRnjk0BVXNR4mgM4XnW1DJDjjWgtttNOlQzWt1GaVDM=";
        };

        site = pkgs.stdenvNoCC.mkDerivation {
          name = "blog-site";
          inherit src;

          nativeBuildInputs = [hugo];

          buildPhase = ''
            export HOME=$NIX_BUILD_TOP
            ln -s ${modules} _vendor
            hugo --minify --destination $out
          '';

          dontInstall = true;
        };

        root = pkgs.runCommand "blog-root" {} ''
          mkdir -p $out/etc/nginx $out/usr/share/nginx
          cp ${./nginx.conf} $out/etc/nginx/nginx.conf
          cp ${pkgs.nginx}/conf/mime.types $out/etc/nginx/mime.types
          ln -s ${site} $out/usr/share/nginx/html
        '';

        image = pkgs.dockerTools.buildLayeredImage {
          name = "blog";
          tag = "latest";
          contents = [root];

          extraCommands = ''
            mkdir -p tmp
            chmod 1777 tmp
          '';

          config = {
            Cmd = [
              "${pkgs.lib.getExe pkgs.nginx}"
              "-c"
              "/etc/nginx/nginx.conf"
              "-e"
              "/dev/stderr"
              "-g"
              "daemon off;"
            ];
            ExposedPorts."8080/tcp" = {};
            User = "65534:65534";
          };
        };
      in {
        inherit image modules site;
        default = site;
      }
    );

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = [(hugoFor pkgs) pkgs.go];
        };
      }
    );
  };
}
