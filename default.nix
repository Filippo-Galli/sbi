{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  matplotlib,
  joblib,
  scipy,
  scikit-learn,
  tensorboard,
  torch,
  skorch,
  tqdm,
  torchtestcase,
  nflows,
  zuko,
  lib,
  pytest-harvest,
  pkg-resources-backport,
  pytestCheckHook,
  nbformat,
  nbclient,
  nbconvert,
  pyro-ppl,
  pytest-xdist,
  pymc,
}:
let
  pytest-harvest-patched = pytest-harvest.overridePythonAttrs (old: {
    build-system = (old.build-system or [ ]) ++ [
      pkg-resources-backport
    ];
  });

in
buildPythonPackage (finalAttrs: {
  pname = "sbi";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "sbi-dev";
    repo = "sbi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a6T7xa7zXr7rhNV3wikE/yrXSNhJ4PDRa/EF0+/CudA=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
    joblib
    scipy
    scikit-learn
    tensorboard
    torch
    skorch
    tqdm
    nflows
    zuko
  ];

  pythonImportsCheck = [ "sbi" ];

  doCheck = false;
  nativeCheckInputs = [
    pytestCheckHook
    pytest-harvest-patched
    nbformat
    nbclient
    nbconvert
    torchtestcase
    pyro-ppl
    pytest-xdist
    pymc
  ];

  meta = {
    description = "Python package for simulation-based inference";
    homepage = "https://sbi.readthedocs.io/en/stable/";
    changelog = "https://github.com/sbi-dev/sbi/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Filippo-Galli
    ];
  };

})
