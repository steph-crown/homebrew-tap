class AseShell < Formula
  desc "àṣẹ – a small Unix-style interactive shell in Rust"
  homepage "https://github.com/steph-crown/ase"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.1/ase-shell-aarch64-apple-darwin.tar.xz"
      sha256 "6c0b08fa8f3b42f89d66ea53d02db17f12e72b357bde7c1c7e844d5cfb4aa9eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.1/ase-shell-x86_64-apple-darwin.tar.xz"
      sha256 "c5b920eaee3cbdba29fd9a041bf92d2c11f8757d35071d3f7a7890cbec659272"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.1/ase-shell-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b93244c7683c3d4eba6e536dc7028158b84805efac6675e3de81a00b2987817c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.2.1/ase-shell-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb697dc7dd27e2486a356fc8ecd55561d84b84db022a820e01024ea814f5176a"
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
