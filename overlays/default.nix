self: super:
{
  todofish = super.callPackage ./todofish.nix {};
  todo-txt-again = super.callPackage ./todoagain.nix {};
}
