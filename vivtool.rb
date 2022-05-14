# typed: false
# frozen_string_literal: true

# Formula for the "vivtool" utility for connecting to Viiiiva heart rate
# monitors.
class Vivtool < Formula
  desc "Connect to Viiiiva heart rate monitors"
  homepage "https://github.com/p00ya/vivian"
  license "Apache-2.0"
  head "https://github.com/p00ya/vivian.git", branch: "main"
  stable do
    url "https://github.com/p00ya/vivian.git",
      using:    :git,
      tag:      "v1.0.0",
      revision: "74b8bf9ca4be025e1eb93145d35c93edccf4f81d"
  end

  depends_on xcode: ["13.2", :build]

  def install
    chdir "vivtool" do
      system "swift", "build", "-c", "release", "--disable-sandbox", "--static-swift-stdlib"
    end
    bin.install "vivtool/.build/release/vivtool"
    man1.install "vivtool/vivtool.1"
  end

  test do
    system "${bin}/vivtool", "--help"
  end
end
