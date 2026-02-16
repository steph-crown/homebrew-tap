class AseShell < Formula
  desc "àṣẹ – a small Unix-style interactive shell in Rust"
  homepage "https://github.com/steph-crown/ase"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.0/ase-shell-aarch64-apple-darwin.tar.xz"
      sha256 "4232bdcbf898b1b1d9c4b007787efc859d55a3a41ca365a39b395374b5464eed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.0/ase-shell-x86_64-apple-darwin.tar.xz"
      sha256 "98f31e88df1cb52ec2e7c6c3e8a3a602a696b6a24c1a78b12676733001fb30c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.0/ase-shell-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b6f5e0ab90600a6b5d8dd15b1d59ca1ec039fcd02e4f37cfc971d389ce049809"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.0/ase-shell-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8687e6b7f25c660e495d1e22f0b0b09c17ef6da815b89d9f405da61ca2333052"
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
