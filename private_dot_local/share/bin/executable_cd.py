#!/usr/bin/env python

import argparse


# add directories here
dirs: dict[str, str] = {
    "a": "hi"
}


def main():
    parser = argparse.ArgumentParser(description="Simple python script to navigate predetermined directories.")
    parser.add_argument("target", type=str, help="Destination shortcut.")

    args = parser.parse_args()

    print("args")
    


if __name__ == "__main__":
    main()

