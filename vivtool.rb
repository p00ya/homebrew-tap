# typed: false
# frozen_string_literal: true

# Formula for the "vivtool" utility for connecting to Viiiiva heart rate
# monitors.
class Vivtool < Formula
  desc "Connect to Viiiiva heart rate monitors"
  homepage "https://github.com/p00ya/vivian"
  license "Apache-2.0"
  head "https://github.com/p00ya/vivian.git"
  stable do
    url "https://github.com/p00ya/vivian.git",
      using:    :git,
      tag:      "v0.2.1",
      revision: "8c81e9256aa2efbc4529ef1ed2c6d7bc905ef306"
  end

  depends_on xcode: ["13.2", :build]

  def setup_fake_sandbox_exec
    # Workaround for sandbox errors: place a dummy sandbox-exec on PATH.
    # See: https://github.com/Homebrew/discussions/discussions/59
    build_bin = "#{buildpath}/bin"
    Dir.mkdir(build_bin)

    script = <<~SH
      #!/bin/bash
      # If a trivial sandbox command can run, then use the system sandbox.
      if /usr/bin/sandbox-exec -p '(version 1)' true ; then
        exec /usr/bin/sandbox-exec "$@"
      fi
      # If a trivial sandbox command fails, we may already be in a sandbox,
      # so don't initialize a new sandbox.
      while getopts ":f:n:p:D:" opt ; do : ; done
      shift $((OPTIND -1))
      exec "$@"
    SH
    File.write("#{build_bin}/sandbox-exec", script, perm: 0755)
    ENV["PATH"] = "#{build_bin}:#{ENV["PATH"]}"
  end

  def install
    setup_fake_sandbox_exec

    xcodebuild "-project", "vivian.xcodeproj",
        "-scheme", "vivtool",
        "-disableAutomaticPackageResolution",
        "-configuration", "Release",
        "clean", "install",
        "DSTROOT=build",
        # Must use absolute path for SYMROOT for SPM dependencies to be
        # visible.
        "SYMROOT=#{buildpath}/build"
    bin.install "build/bin/vivtool"
    man1.install "build/share/man/man1/vivtool.1"
  end

  test do
    system "${bin}/vivtool", "--help"
  end
end
