{ symlinkJoin, lib, st-unwrapped, makeWrapper, writeShellScriptBin, startScript ? null }:

symlinkJoin {
  name = "st";

  paths = [
    st-unwrapped
  ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/st \
    ${lib.optionalString (startScript != null) ''--add-flags "-e ${startScript}" "$@"''} \
  '';
}
