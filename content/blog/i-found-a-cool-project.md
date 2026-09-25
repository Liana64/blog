+++
title = "I found a cool project"
date = 2026-09-23
draft = false
+++

I came across a project today called [Spectrum OS](https://spectrum-os.org/design.html) which I am pleased to say is the *coolest and most exciting idea I have found people talking about in awhile*. I like sandboxing. I like knowing that all the little computer instructions are neatly tucked into their little boxes.

I discovered [systemd unit hardening](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html) this year and have been playing around with `systemd-analyze security`. I use faillock and usbguard now, and I qualified for a Red Hat certification on Linux Security with the help of a course from [Sander Van Vugt](www.sandervanvugt.com) which was fun! I don't claim to be an *expert* on it, though. I mean, I'm not contributing to LSM projects in the Linux kernel, and I still don't even fully understand mmap.

Recently I've been using hardware security keys more too. I issued a GPG key, cloned it to three YubiKeys, and setup SSH over FIDO which has been very useful. I like knowing that I can actually use GPG without worrying about losing a key. I also like the fact that I have to physically verify actions.

Anyway, I tried QubesOS many years ago and thought it was cool as a concept but very clunky and difficult for everyday use. I switched to openSUSE, then later to NixOS because the framework laptop I purchased was stuck in customs and I wanted to work on my OS.

Incidentally, it turns out that I love NixOS. It feels like I can design an operating system that is an [extension of my body](https://www.scd31.com/posts/nix-files-are-intimate).

Lose the hardware I use? No problem, I can spin up the same environment in minutes. It makes me feel less attached to my posessions, which is appealing to me [as a buddhist](https://hermesamara.org/teachings). I like knowing that my OS is saved in version control, moreover that I can locally rollback changes whenever I want because of its atomicity. Packages are locked within a flake, and builds are in theory reproducible and verifiable.

Plus, the community around NixOS is huge and there are so many nixpkgs.

All of this is to say that I was very pleased to find this project, and that I feel motivated to get back into software. I just need to rewrite my dotfiles from scratch and maybe de-slop my corroded psyche from being addicted to using LLMs.

*I started writing about why I quit working in software and became a hardware engineer in the first place and quickly realized that I should write a separate post about that*
