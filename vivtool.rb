# frozen_string_literal: true

class Vivtool < Formula
  desc "Connect to Viiiiva heart rate monitors"
  homepage "https://github.com/p00ya/vivian"
  license "Apache-2.0"
  head "https://github.com/p00ya/vivian.git", branch: "develop"

  # Xcode 11.4 is the first Xcode version with Swift 5.2.
  depends_on xcode: ["11.4", :build]

  def install
    xcodebuild "-project", "vivian.xcodeproj",
        "-scheme", "vivtool",
        "-disableAutomaticPackageResolution",
        "-configuration", "Release",
        "clean", "install",
        "DSTROOT=build",
        # Must use absolute path for SYMROOT for SPM dependencies to be
        # visible.
        "SYMROOT=#{buildpath}/build"
    bin.install "build/usr/local/bin/vivtool"
    man1.install "build/usr/local/share/man/man1/vivtool.1"
  end

  test do
    system "${bin}/vivtool", "--help"
  end
end
