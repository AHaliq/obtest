{ system ? builtins.currentSystem
, obelisk ? import ./.obelisk/impl {
    inherit system;
    iosSdkVersion = "13.2";

    # You must accept the Android Software Development Kit License Agreement at
    # https://developer.android.com/studio/terms in order to build Android apps.
    # Uncomment and set this to `true` to indicate your acceptance:
    # config.android_sdk.accept_license = false;

    # In order to use Let's Encrypt for HTTPS deployments you must accept
    # their terms of service at https://letsencrypt.org/repository/.
    # Uncomment and set this to `true` to indicate your acceptance:
    # terms.security.acme.acceptTerms = false;
  }
}:
with obelisk;
project ./. ({ pkgs, ... }: {
  android.applicationId = "systems.obsidian.obelisk.examples.minimal";
  android.displayName = "Obelisk Minimal Example";
  ios.bundleIdentifier = "systems.obsidian.obelisk.examples.minimal";
  ios.bundleName = "Obelisk Minimal Example";
  packages = {
    baby-l4 = ./baby-l4;
  };
  overrides = self: super: let
    gf-udSrc = pkgs.fetchFromGitHub {
      owner = "GrammaticalFramework";
      repo = "gf-ud";
      rev = "4b0760e02f9efdb8fbdd47ed2258e9b89f15a14d";
      sha256 = "12y94z3ibrrx0ylwr66i3ibrraj2bzjq97gcnqv71k40z56zk42h";
    };
    aceSrc = pkgs.fetchFromGitHub {
      owner = "SlimTim10";
      repo = "reflex-dom-ace";
      rev = "5d086c871892b9ebf7c66ad2d4d4f84023bea9b2";
      sha256 = "0vizlf691s1rbkilhf23c79vkb6pns2x4b6b94szn9wd8mjizxyc";
    };
  in
  {
    gf-ud = self.callCabal2nix "gf-ud" gf-udSrc {};
    reflex-dom-ace = self.callCabal2nix "reflex-dom-ace" aceSrc {};
    # lsp = self.callHackageDirect {
    #   pkg = "lsp";
    #   ver = "1.1.1.0";
    #   sha256 = "sha256:0lcqiw5304llxamizza28xy4llhmmrr3dkvlm4pgrhzfcxqwnfrm";
    # } {};
    # lsp-types = self.callHackageDirect {
    #   pkg = "lsp-types";
    #   ver = "1.1.0.0";
    #   sha256 = "sha256:1l8g7iq9zsq19hxamy37hf61bmld500pha2xcwwqs7hk53k9wgn8";
    # } {};
    lsp = null;
    lsp-types = null;
    lsp-test = null;
    # lsp-test = self.callHackageDirect {
    #   pkg = "lsp-test";
    #   ver = "0.13.0.0";
    #   sha256 = "sha256:1b0p678bh4h1mfbi1v12g9zhnyhgq5q3fiv491ni461v44ypr6bn";
    # } {};
    # sbv = self.callHackageDirect {
    #   pkg = "sbv";
    #   ver = "8.9";
    #   sha256 = "sha256:1bmvibjwdn9pbpmslbjx4jlki9djyv2wa8gm33wxfvvrp3fv6hci";
    # } {};
    # gf-ud = null;
    gf = self.callHackageDirect {
      pkg = "gf";
      ver = "3.11";
      sha256 = "1z0dv703g9bn0b6ardxvbx7wrvzj2za6zxsmy2yx2m3bzihba113";
    } {};
    # unliftio-core = self.callHackageDirect {
    #   pkg = "unliftio-core";
    #   ver = "0.2.0.1";
    #   sha256 = "06cbv2yx5a6qj4p1w91q299r0yxv96ms72xmjvkpm9ic06ikvzzq";
    # } {};
    # jsaddle = self.callHackageDirect {
    #   pkg = "jsaddle";
    #   ver = "0.9.7.1";
    #   sha256 = "1y5kgfp6wl48jrfw8w09smggv0qz5q25qac4kj4zmikkhicb7s8m";
    # } {};
    # resourcet = self.callHackageDirect {
    #   pkg = "resourcet";
    #   ver = "1.2.4.3";
    #   sha256 = "14snj25sh22zgygqjdq20nj0pzkj430ma90h0624q38ij9nphjs1";
    # } {};
    # parser-combinators = self.callHackageDirect {
    #   pkg = "parser-combinators";
    #   ver = "1.3.0";
    #   sha256 = "1yr03mlhjvrx719f4bppk6c86wv1ib0dmb8wsamy0552zaghygc2";
    # } {};
    sbv = null;
  };
})
