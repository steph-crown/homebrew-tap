class AseShell < Formula
  desc "àṣẹ – a small Unix-style interactive shell in Rust"
  homepage "https://github.com/steph-crown/ase"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.2/ase-shell-aarch64-apple-darwin.tar.xz"
      sha256 "f072decf484ddc99dc2c75680e9c54250b6f255288c9e943d832fa4c8e319d3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.2/ase-shell-x86_64-apple-darwin.tar.xz"
      sha256 "9c484657934f1eeb34ae062662744b623cecb13dcca4d609bba7f845afcaaf3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.2/ase-shell-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70caeff26d1e78a8a12a4f59b52e5d0b741f8ccd89fa421c1da6569c87fd43e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.2/ase-shell-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73df53f3ba5f1ccdeaed58b7ea1d4bfac9ddd627a4e9825086adb5b6d34832c5"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ase" if OS.mac? && Hardware::CPU.arm?
    bin.install "ase" if OS.mac? && Hardware::CPU.intel?
    bin.install "ase" if OS.linux? && Hardware::CPU.arm?
    bin.install "ase" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
