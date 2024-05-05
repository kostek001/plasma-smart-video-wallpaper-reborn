{ stdenv
, cmake
, kdePackages
, qt6
, lib
}:

stdenv.mkDerivation {
  pname = "plasma-smart-video-wallpaper-reborn";
  version = "24-04-2024";

  src = ./.;

  nativeBuildInputs = [ cmake qt6.wrapQtAppsHook kdePackages.extra-cmake-modules ];

  propagatedBuildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
  ] ++ (with kdePackages; [
    libplasma
    kdeclarative
    qt5compat
    plasma5support
    kirigami
    kcoreaddons
  ]);
  strictDeps = true;

  meta = with lib; {
    description = "Plasma 6 Wallpaper plugin to play videos on your Desktop/Lock Screen.";
    license = licenses.gpl2;
    homepage = "https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn";
  };
}
