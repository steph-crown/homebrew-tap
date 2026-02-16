class AseShell < Formula
  desc "àṣẹ – a small Unix-style interactive shell in Rust"
  homepage "https://github.com/steph-crown/ase"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.1.3/ase-shell-aarch64-apple-darwin.tar.xz"
      sha256 "701253ccc8b873df7be6013636881b1331ff2d3475a44a75a66e60799bab99ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.1.3/ase-shell-x86_64-apple-darwin.tar.xz"
      sha256 "177ecf041e03b9a146bb1c0ae741414cf077f1adef0916d2670d0e4636b42399"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/steph-crown/ase/releases/download/v0.1.3/ase-shell-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "29197ca98ed594a9b98f3841b91a3939ea4d73eb09420e86c462bac89a9b7e5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/steph-crown/ase/releases/download/v0.1.3/ase-shell-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3187694ac7c47a0906575ca5f29a9ae1e51f5ef5cf709dd4cb0e5d3ada391411"
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
