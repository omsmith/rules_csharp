def _csharp_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            runtime = ctx.file.runtime,
            compiler = ctx.file.compiler,
        ),
    ]

csharp_toolchain = rule(
    _csharp_toolchain_impl,
    attrs = {
        "runtime": attr.label(
            executable = True,
            allow_single_file = True,
            mandatory = True,
            cfg = "host",
        ),
        "compiler": attr.label(
            executable = True,
            allow_single_file = True,
            mandatory = True,
            cfg = "host",
        ),
    },
)

# This is called in BUILD
def configure_toolchain(os, exe = "dotnet"):
    csharp_toolchain(
        name = "csharp_x86_64-" + os,
        runtime = "@netcore-runtime-%s//:%s" % (os, exe),
        compiler = "@csharp-build-tools//:tasks/netcoreapp2.1/bincore/csc.dll",
    )

    native.toolchain(
        name = "csharp_%s_toolchain" % os,
        exec_compatible_with = [
            "@platforms//os:" + os,
            "@platforms//cpu:x86_64",
        ],

        # TODO: this will need to change when we build someting other then .NET 4.x
        target_compatible_with = [
            "@platforms//os:windows",
        ],
        toolchain = "csharp_x86_64-" + os,
        toolchain_type = ":toolchain_type",
    )
