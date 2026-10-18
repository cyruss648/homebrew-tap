cask "snow-shot" do
  arch arm: "arm64", intel: "x86_64"

  version "1.3.2"
  sha256 arm:   "c783e63b7eb4764f0337796d54b13e6631aaa12547219f50e2a1717949eb0f71",
         intel: "6ca11ad2f596a75ce8581324915daf430879d1d4dccad48e7a9317d3c12db9cd"

  url "https://github.com/mg-chao/snow-apps/releases/download/v#{version}_snow-shot/snow-shot-#{version}-macos-#{arch}-homebrew.tar.gz"
  name "Snow Shot"
  desc "Screenshot and screen recording application"
  homepage "https://snowshot.top/"

  depends_on macos: :sequoia

  app "Snow Shot.app"
  # Installer scripts run before app artifacts and preserve HOME and Keychain access.
  installer script: {
    executable:   "/bin/bash",
    args:         [staged_path.join("prepare-snow-shot-homebrew.sh"),
                   staged_path.join("snow-shot-#{version}-macos-#{arch}.dmg"),
                   staged_path.join("Snow Shot.app")],
    must_succeed: true,
    print_stderr: true,
  }

  # Homebrew removes the app; retain the signing identity and user data.
  uninstall quit: "com.snowshot.snow_shot"

  caveats <<~EOS
    Snow Shot reuses a signing identity in your login Keychain. The first install
    may request Keychain access. Grant Screen Recording and Accessibility when
    macOS requests them. Local signing does not provide Apple notarization.
    Keep ~/Library/Application Support/Snow Shot/Installer and its Keychain
    identity across upgrades and reinstalls. Use the same installing account.
  EOS
end
