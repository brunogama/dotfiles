#/usr/bin/env zsh

POLICY_JSON=$(cat <<- _EOF_
{
    "HomepageLocation": "www.chromium.org",
    "ExtensionInstallSources": [
        "https://corp.mycompany.com/*",
        "https://*.github.com/*",
        "http://userscripts.org/*"
    ]
}
_EOF_
)

sudo mkdir -p /etc/opt/chrome/managed
sudo mkdir -p /etc/opt/chrome/policies/managed
sudo mkdir -p /etc/opt/chrome/policies/recommended
sudo chmod -w /etc/opt/chrome/policies/managed
sudo touch /etc/opt/chrome/policies/managed/test_policy.json
sudo touch /etc/chromium-browser/policies/managed/test.json
sudo echo "$POLICY_JSON" > /etc/opt/chrome/policies/managed/test_policy.json
sudo echo "$POLICY_JSON" > /etc/chromium-browser/policies/managed/test.json