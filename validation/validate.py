import subprocess
from pathlib import Path

# --------------------
# Global configuration
# --------------------

SAXON_JAR = Path("lib/saxon9he.jar")
SCHEMATRON_DIR = Path("schematron")
RULES_DIR = Path("rules")
TESTS_DIR = Path("error-test-files")
SVRL_ROOT = Path("svrl")


# --------------------
# Utility
# --------------------

def run(cmd):
    print("▶", " ".join(cmd))
    subprocess.run(cmd, check=True)


# --------------------
# Compile step
# --------------------

def compile_schematron(language: str):
    """
    Compile Schematron rules for a given SBGN language (pd / er / af)
    into an XSLT validator.
    """
    language = language.lower()

    sch_file = RULES_DIR / f"sbgn_{language}.sch"
    step1 = Path(f"sbgn_{language}.step1.sch")
    step2 = Path(f"sbgn_{language}.step2.sch")
    validator = Path(f"sbgn_{language}_validator.xsl")

    print(f"\n=== Compiling Schematron for {language.upper()} ===")

    # Step 1: expand includes
    run([
        "java", "-jar", str(SAXON_JAR),
        "-s:" + str(sch_file),
        "-xsl:" + str(SCHEMATRON_DIR / "iso_dsdl_include.xsl"),
        "-o:" + str(step1)
    ])

    # Step 2: expand abstract patterns
    run([
        "java", "-jar", str(SAXON_JAR),
        "-s:" + str(step1),
        "-xsl:" + str(SCHEMATRON_DIR / "iso_abstract_expand.xsl"),
        "-o:" + str(step2)
    ])

    # Step 3: compile to SVRL-producing XSLT
    run([
        "java", "-jar", str(SAXON_JAR),
        "-s:" + str(step2),
        "-xsl:" + str(SCHEMATRON_DIR / "iso_svrl_for_xslt1.xsl"),
        "-o:" + str(validator)
    ])

    print(f" Validator created: {validator}")
    return validator


# --------------------
# Validation step
# --------------------

def validate_sbgn(language: str, sbgn_file: Path):
    """
    Validate a single SBGN file and write SVRL output.
    """
    language = language.upper()

    validator = Path(f"sbgn_{language.lower()}_validator.xsl")
    svrl_dir = SVRL_ROOT / language
    svrl_dir.mkdir(parents=True, exist_ok=True)

    output = svrl_dir / (sbgn_file.stem + ".svrl")

    print(f"\n=== Validating {sbgn_file.name} ({language}) ===")

    run([
        "java", "-jar", str(SAXON_JAR),
        "-s:" + str(sbgn_file),
        "-xsl:" + str(validator),
        "-o:" + str(output)
    ])

    print(f"SVRL written to {output}")


# --------------------
# Batch validation
# --------------------

def validate_all(language: str):
    """
    Validate all test files for a given language.
    """
    language = language.upper()
    test_dir = TESTS_DIR / language

    for sbgn in sorted(test_dir.glob("*.sbgn")):
        validate_sbgn(language, sbgn)


# --------------------
# Entry point
# --------------------

if __name__ == "__main__":

    pd = "pd"
    af = "af"
    er = "er"
    #compile_schematron(pd)
    compile_schematron(af)
    validate_all(af)
