#!/bin/env python3

import sys
import subprocess

disk_image = sys.argv[1]
lotus_command = [
    "lotus-system-x86_64",
    "-hda", disk_image,
    "-serial", "mon:stdio",
    "-nographic",
    "-rtc", "base=localtime",
    "-no-reboot",
    "-m", "1G"]

lotus_proc = subprocess.Popen(
    lotus_command,
    stdout=subprocess.PIPE,
    stdin=subprocess.PIPE)

lotus_stdin = lotus_proc.stdin
lotus_stdout = lotus_proc.stdout

while True:
    if lotus_proc.poll() != None:
        sys.exit(-1)

    message = lotus_stdout.readline().decode(errors='replace').strip()

    if message == 'test: PASSED':
        lotus_proc.kill()
        sys.exit(0)

    elif message == 'test: FAILED':
        lotus_proc.kill()
        sys.exit(-1)

    elif message != '':
        print(message)
