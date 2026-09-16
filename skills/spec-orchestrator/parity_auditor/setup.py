# Copyright Gint Atkinson, gint.atkinson@gmail.com

from setuptools import find_packages, setup

if __name__ == "__main__":
    setup(
        name="parity_auditor",
        version="0.1.0",
        package_dir={"": "src"},
        packages=find_packages(where="src"),
        entry_points={
            "console_scripts": [
                "parity-auditor = parity_auditor.cli:main",
            ],
        },
    )

