# certbot-DNS-challenge-hooks

Simple scripts I use to auto renew my Let's encrypt wildcard SSL cert.

But use [acme.sh](https://github.com/Neilpang/acme.sh) is always recommended.

## Usage

- Apply for a certificate use `certbot` and `dns-01` challenge
- Download this repo
- open `config.sh` of this repo, fill the `CLOUDFLARE_KEY` and `CLOUDFLARE_EMAIL` variables
- install `jq` package from your system package manager (apt, yum, etc)
- Add a crontab job (as root) as bellow:

```bash
certbot renew --manual-auth-hook="/path/to/cloned/repo/cloudflare-update-dns.sh" --manual-cleanup-hook="/path/to/cloned/repo/cloudflare-clean-dns.sh" --post-hook="systemctl reload nginx" >> /path/to/log/crontab.renew.log
```

## Example

```bash
sudo certbot renew --manual-auth-hook="/etc/letsencrypt/scripts/cloudflare-update-dns.sh" --manual-cleanup-hook="/etc/letsencrypt/scripts/cloudflare-clean-dns.sh" --post-hook="systemctl reload nginx" --dry-run

Saving debug log to /var/log/letsencrypt/letsencrypt.log

-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/7sdre.am.conf
-------------------------------------------------------------------------------
Cert not due for renewal, but simulating renewal for dry run
Plugins selected: Authenticator manual, Installer None
Renewing an existing certificate
Performing the following challenges:
dns-01 challenge for 7sdre.am
dns-01 challenge for 7sdre.am
Output from cloudflare-update-dns.sh:
CHALLENGE_DOMAIN: _acme-challenge.7sdre.am
CHALLENGE_VALUE: q_nAln58kJ0M8iaih2dWo_jMlYwogj_iIBQjj2LEIeU
DNS_SERVER: 8.8.8.8
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47
Add record result: true
DNS records have not been propagate, sleep 10s...
DNS record have been propagated, finish

Output from cloudflare-update-dns.sh:
CHALLENGE_DOMAIN: _acme-challenge.7sdre.am
CHALLENGE_VALUE: anaxLO1rs2XSTlDwOXiMSdgazBsr8erX5l-Tdx5KRAI
DNS_SERVER: 8.8.8.8
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47
Add record result: true
DNS records have not been propagate, sleep 10s...
DNS records have not been propagate, sleep 10s...
DNS record have been propagated, finish

Waiting for verification...
Cleaning up challenges
Output from cloudflare-clean-dns.sh:
DOMAIN: _acme-challenge.7sdre.am
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47
a0ba72127de4db56eea3541491cdbd36
clean: a0ba72127de4db56eea3541491cdbd36
true
clean: c11557b6f7766cc2749a36864a14584c
true
clean: 2191aed49f646c5c64209be36a2d3788
true

Output from cloudflare-clean-dns.sh:
DOMAIN: _acme-challenge.7sdre.am
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47



-------------------------------------------------------------------------------
new certificate deployed without reload, fullchain is
/etc/letsencrypt/live/7sdre.am/fullchain.pem
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates below have not been saved.)

Congratulations, all renewals succeeded. The following certs have been renewed:
  /etc/letsencrypt/live/7sdre.am/fullchain.pem (success)
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates above have not been saved.)
-------------------------------------------------------------------------------
Running post-hook command: systemctl reload nginx
```

## LICENSE

WTFPL
