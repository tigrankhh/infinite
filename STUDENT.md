# Recover the destinations

The Bash script `unlock.sh` is broken. Repair it so it prints two complete HTTPS URLs: the challenge website and the token instructions website.

Run it with `bash unlock.sh`. Work on Linux with Bash 4 or newer. Only Bash and standard tools (`cat`, `sort`, `printf`) are required. No network access is needed by the script.

Rules:
- Preserve every encoded packet exactly.
- Repair the existing decoder and assembly functions; do not hardcode the destinations or replace the program with a separate decoder.
- Do not suppress errors or disable strict mode as the final fix.
- Explain each meaningful repair in your submission.

Packet format: `label|sequence|hex_data`. Sequences start at zero. Each hex pair encodes one character XORed with decimal 37. The original program must recover the characters and assemble packets in ascending numeric sequence order for each label.

After recovery, read the token instructions website. Obtain the Bandit Level 5 password and use it as the `token` query parameter on the challenge website.
