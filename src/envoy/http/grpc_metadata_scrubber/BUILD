load(
    "@envoy//bazel:envoy_build_system.bzl",
    "envoy_cc_library",
    "envoy_cc_test",
)

package(
    default_visibility = [
        "//src/envoy:__subpackages__",
    ],
)

envoy_cc_library(
    name = "filter_factory",
    srcs = ["filter_factory.cc"],
    repository = "@envoy",
    deps = [
        ":filter_lib",
        "@envoy//source/exe:all_extensions_lib",
    ],
)

envoy_cc_library(
    name = "filter_lib",
    srcs = [
        "filter.cc",
    ],
    hdrs = [
        "filter.h",
        "filter_config.h",
    ],
    repository = "@envoy",
    deps = [
        "//api/envoy/v12/http/grpc_metadata_scrubber:config_proto_cc_proto",
        "@envoy//source/common/grpc:common_lib",
        "@envoy//source/common/http:headers_lib",
        "@envoy//source/extensions/filters/http/common:pass_through_filter_lib",
    ],
)

envoy_cc_test(
    name = "filter_test",
    srcs = [
        "filter_test.cc",
    ],
    repository = "@envoy",
    deps = [
        ":filter_lib",
        "@envoy//source/common/common:empty_string",
        "@envoy//test/mocks/server:server_mocks",
        "@envoy//test/test_common:utility_lib",
    ],
)
