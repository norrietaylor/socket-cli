# pnpm 12 for SocketDev fleet repos. Named pnpm12 because a repo layer
# cannot shadow the upstream `pnpm` package (11.x); never install both.
#
# The fleet pins pnpm 12.5.1 (.github/actions/fleet/setup/external-tools.generated.json)
# and its pnpm-workspace.yaml uses pnpm 12 features (`pipelines:`), while
# gominimal/pkgs still ships pnpm 11.x. pnpm 12 is a native (Rust) binary;
# its npm tarball is only a stub that downloads the binary on first run, so
# this takes the GitHub release asset directly. The sha512 of each asset
# matches the fleet's own integrity pin.
# A repo layer cannot import upstream specs by relative path; `upstream "<name>"`
# resolves them from the pinned gominimal/pkgs layer.
let { subsetOf, upstream, Attrs, BuildSpec, Local, OutputBin, OutputData, Source, .. } = import "minimal.ncl" in
let { target, .. } = import "config.ncl" in

let version = "12.5.1" in
{
  name = "pnpm12",
  build_deps = [
    { file = "build.sh" } | Local,
    match {
      { arch = 'Amd64, .. } =>
        {
          url = "https://github.com/pnpm/pnpm/releases/download/v%{version}/pnpm-linux-x64.tar.gz",
          sha256 = "5a397dfb6b3d4b07d3d7769586aeb471048faf04299a492e2808b95a9a1c701f",
          extract = true,
        } | Source,
      { arch = 'Arm64, .. } =>
        {
          url = "https://github.com/pnpm/pnpm/releases/download/v%{version}/pnpm-linux-arm64.tar.gz",
          sha256 = "84e1290e82c800acd406b6db27e9650e15db3c2344d12162cc305ea1f942c6ff",
          extract = true,
        } | Source,
    } target,
    upstream "base",
  ],
  runtime_deps = [
    upstream "glibc",
    subsetOf (upstream "gcc") ["libgcc"],
  ],

  cmd = "./build.sh",
  build_args = {
    include version,
  },

  outputs = {
    pnpm = { glob = "usr/bin/pnpm" } | OutputBin,
    pnpx = { glob = "usr/bin/pnpx" } | OutputBin,
    libexec = { glob = "usr/libexec/pnpm/**" } | OutputData,
  },
  attrs =
    {
      upstream_version = version,
      license_spdx = "MIT",
      source_provenance = {
        category = 'GithubRepo,
        owner = "pnpm",
        repo = "pnpm",
      },
    } | Attrs,
} | BuildSpec
