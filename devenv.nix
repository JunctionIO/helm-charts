{ pkgs, ... }:
{
  packages = [
    pkgs.kubernetes-helm
    pkgs.kubectl
  ];
}
