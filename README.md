# diffusers-docker-repro

Copyright (c) 2022 by Gadi Cohen.  MIT Licensed.

This is the docker image I've been using for debugging diffusers in a
consistent environment.

It's setup for dreambooth training can be used for anything. Will happily
accept PRs to add useful fixtures for other tests.

## Usage:

1. git clone
1. Review the `Dockerfile` but it should be good
1. Set `HF_AUTH_TOKEN` environment variable to your HuggingFace token.
1. `docker build -t diffusers --build-arg HF_AUTH_TOKEN=$HF_AUTH_TOKEN .`
1. `docker run -it diffusers`

At this point you'll get a shell inside the container and can play
around in it however you want (particularly to `git checkout`
particular commits).

## git bisect

If you're hunting for a recently introduced bug, `git bisect` is an
amazing tool.  You can read up about it but in short:

```bash
$ cd .. # back to git root (from diffusers src directory)

$ git bisect
$ git good <last-known-working-commit>
$ git bad <first-known-unworking-commit>

# Git will now perform a binary search and drop you in the middle
# Run your test case
$ git good # if it works, OR
$ git bad # if it fails

# Repeat the procss until git gives you the answer

$ git reset # to end the session
```

If you can narrow your test case into a script that returns an error code,
you can automate the above process.