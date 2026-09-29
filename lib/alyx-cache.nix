{
  # Alyx is always-on; Gordon pulls from this over Tailscale.
  # Harmonia only serves paths already in Alyx's store (shared FODs).
  substituter = "http://alyx:5001";
  publicKey = "alyx-1:sbuk31odZ0wyFgvglikxcRbTlE8FAOJSmJFRFCALIJU=";
  # 5000 is AirPlay Receiver on macOS (Control Center).
  port = 5001;
  secretKeyPath = "/var/lib/harmonia/secret";
}
