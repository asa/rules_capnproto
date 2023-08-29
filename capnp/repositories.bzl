load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//capnp/internal:capnp_lang_toolchain_gen.bzl", "capnp_lang_toolchain_gen")
load("//capnp/internal:capnp_toolchain_gen.bzl", "capnp_toolchain_gen")
load(
    "//capnp/toolchain_defs:cc_defs.bzl",
    "CC_LANG_PLUGIN",
    "CC_LANG_REPO",
    "CC_LANG_RUNTIME",
    "CC_LANG_SHORTNAME",
)
load(
    "//capnp/toolchain_defs:toolchain_defs.bzl",
    "CAPNP_TOOLCHAIN_DEFAULT_CAPNP_TOOL",
    "CAPNP_TOOLCHAIN_REPO",
)

def capnp_dependencies():
    maybe(
        new_git_repository,
        name = "capnproto",
        build_file = "@rules_capnproto//third_party/capnproto:BUILD.capnp.bazel",
        remote = "https://github.com/asa/capnproto.git",
        commit = "c6fb91adb36c473b0965198afdf8e944cb8a1321", # the no_bazel branch.
    )

    maybe(
        http_archive,
        name = "zlib",
        build_file = "@rules_capnproto//third_party:BUILD.zlib.bazel",
        sha256 = "629380c90a77b964d896ed37163f5c3a34f6e6d897311f1df2a7016355c45eff",
        strip_prefix = "zlib-1.2.11",
        urls = [
            # TODO(kgreenek): Mirror this somewhere in case github is down.
            # Ideally mirror.bazel.build (ping @philwo on github).
            "https://github.com/madler/zlib/archive/v1.2.11.tar.gz",
        ],
    )

def capnp_toolchain(capnp_tool = CAPNP_TOOLCHAIN_DEFAULT_CAPNP_TOOL):
    capnp_toolchain_gen(
        name = CAPNP_TOOLCHAIN_REPO,
        capnp_tool = capnp_tool,
    )

def capnp_cc_toolchain(plugin = CC_LANG_PLUGIN, runtime = CC_LANG_RUNTIME):
    capnp_lang_toolchain_gen(
        name = CC_LANG_REPO,
        lang_shortname = CC_LANG_SHORTNAME,
        plugin = CC_LANG_PLUGIN,
        runtime = CC_LANG_RUNTIME,
    )
