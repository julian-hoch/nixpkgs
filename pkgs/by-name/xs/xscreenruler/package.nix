{ lib, stdenv, fetchFromGitHub, xorg, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xscreenruler";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "julian-hoch";
    repo = "xscreenruler";
    rev = "v${version}";
    sha256 =
      "11f574gpj6igy0az38z4v66sbpinh4h5gz75p85zff24pzrdj5m1"; # placeholder
  };

  buildInputs = [ xorg.libX11 ];
  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 xscreenruler -t $out/bin
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/xscreenruler \
      --prefix PATH : ${lib.makeBinPath [ xorg.xsetroot ]}
  '';

  meta = with lib; {
    description = "Simple screen ruler for x11. Only xlib in dependencies!";
    homepage = "https://github.com/julian-hoch/xscreenruler";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.julian-hoch ];
  };
}
