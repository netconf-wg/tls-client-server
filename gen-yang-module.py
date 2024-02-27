import re
import csv
import requests
import textwrap
import requests_cache
from io import StringIO
from datetime import datetime

# Metadata for the one YANG module produced by this script
MODULES = [
    {
        "csv_url": "https://www.iana.org/assignments/tls-parameters/tls-parameters-4.csv",
        "spaced_name": "cipher-suite",
        "hypenated_name": "cipher-suite",
        "prefix": "tlscsa",
    }
]


def create_module_begin(module, f):

    # Define template for all four modules
    PREAMBLE_TEMPLATE="""
module iana-tls-HNAME-algs {
  yang-version 1.1;
  namespace "urn:ietf:params:xml:ns:yang:iana-tls-HNAME-algs";
  prefix PREFIX;

  organization
    "Internet Assigned Numbers Authority (IANA)";

  contact
    "Postal: ICANN
             12025 Waterfront Drive, Suite 300
             Los Angeles, CA  90094-2536
             United States of America
     Tel:    +1 310 301 5800
     Email:  iana@iana.org";

  description
    "This module defines identities for the Cipher Suite
     algorithms defined in the 'TLS Cipher Suites' sub-registry
     of the 'Transport Layer Security (TLS) Parameters' registry
     maintained by IANA.

     Copyright (c) YEAR IETF Trust and the persons identified as
     authors of the code. All rights reserved.

     Redistribution and use in source and binary forms, with
     or without modification, is permitted pursuant to, and
     subject to the license terms contained in, the Revised
     BSD License set forth in Section 4.c of the IETF Trust's
     Legal Provisions Relating to IETF Documents
     (https://trustee.ietf.org/license-info).

     The initial version of this YANG module is part of RFC FFFF
     (https://www.rfc-editor.org/info/rfcFFFF); see the RFC
     itself for full legal notices.";

  revision DATE {
    description
      "Reflects contents of the SNAME algorithms registry.";
    reference
      "RFC FFFF: YANG Groupings for TLS Clients and TLS Servers";
  }

  typedef tls-HNAME-algorithm {
    description
      "An enumeration for TLS SNAME algorithms.";
    type enumeration {
"""
    # Replacements
    rep = {
      "DATE": datetime.today().strftime('%Y-%m-%d'),
      "YEAR": datetime.today().strftime('%Y'),
      "SNAME": module["spaced_name"],
      "HNAME": module["hypenated_name"],
      "PREFIX": module["prefix"]
    }
    
    # Do the replacement
    rep = dict((re.escape(k), v) for k, v in rep.items()) 
    pattern = re.compile("|".join(rep.keys()))
    text = pattern.sub(lambda m: rep[re.escape(m.group(0))], PREAMBLE_TEMPLATE)

    # Write preamble into the file
    f.write(text)


def create_module_body(module, f):

    # Fetch the current CSV file from IANA
    r = requests.get(module["csv_url"])
    assert r.status_code == 200, "Could not get " + module["csv_url"]

    # Parse each CSV line
    with StringIO(r.text) as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:

            # Skip reserved algs
            if row["Description"].startswith("Unassigned"):
                continue

            # Skip unassigned algs
            if row["Description"].startswith("Reserved"):
                continue

            # Ensure this is the TLS line
            assert row["Description"].startswith("TLS_"), "Unrecognized description: '" + row["Description"] + "'"

            # Set the 'refs' and 'titles' lists
            if row["Reference"] == "":
                pass # skip when the Reference field is empty

            else:
    
                # There may be more than one ref
                refs = row["Reference"][1:-1]  # remove the '[' and ']' chars
                refs = refs.split("][")
                titles = []
                for ref in refs:
    
                    # Ascertain the ref's title
                    if ref.startswith("RFC"):
    
                        # Fetch the current BIBTEX entry
                        bibtex_url="https://datatracker.ietf.org/doc/"+ ref.lower() + "/bibtex/"
                        r = requests.get(bibtex_url)
                        assert r.status_code == 200, "Could not GET " + bibtex_url
    
                        # Append to 'titles' value from the "title" line
                        for item in r.text.split("\n"):
                            if "title =" in item:
                                title = re.sub('.*{{(.*)}}.*', r'\g<1>', item)
                                if title.startswith("ECDHE\_PSK"):
                                    title = re.sub("ECDHE\\\\_PSK", "ECDHE_PSK", title)
                                titles.append(re.sub('.*{{(.*)}}.*', r'\g<1>', title))
                                break
                        else:
                            raise Exception("RFC title not found")
    
    
                        # Insert a space: "RFCXXXX" --> "RFC XXXX"
                        index = refs.index(ref)
                        refs[index] = "RFC " + ref[3:]
    
                    elif ref == "IESG Action 2018-08-16":

                        # Rewrite the ref value
                        index = refs.index(ref)
                        refs[index] = "IESG Action"

                        # Let title be something descriptive
                        titles.append("IESG Action 2018-08-16")
   
                    elif ref == "draft-irtf-cfrg-aegis-aead-08":

                        # Manually set the draft's title 
                        titles.append("The AEGIS Family of Authenticated Encryption Algorithms")

                    elif ref:
                        raise Exception(f'ref "{ref}" not found')

                    else:
                        raise Exception(f'ref missing: {row}')

            # Write out the enum
            f.write(f'      enum {row["Description"]} {{\n');
            if row["Recommended"] == 'N':
                f.write(f'        status deprecated;\n')
            f.write(f'        description\n')
            description = f'          "Enumeration for the \'{row["Description"]}\' algorithm.";'
            description = textwrap.fill(description, width=69, subsequent_indent="           ")
            f.write(f'{description}\n')
            f.write('        reference\n')
            f.write('          "')
            if row["Reference"] == "":
                f.write('Missing in IANA registry.')
            else:
                ref_len = len(refs)
                for i in range(ref_len):
                    ref = refs[i]
                    f.write(f'{ref}:\n')
                    title = "             " + titles[i]
                    if i == ref_len - 1:
                        title += '";'
                    title = textwrap.fill(title, width=69, subsequent_indent="             ")
                    f.write(f'{title}')
                    if i != ref_len - 1:
                        f.write('\n           ')
            f.write('\n')
            f.write('      }\n')



def create_module_end(f):

    # Close out the enumeration, typedef, and module
    f.write("    }\n")
    f.write("  }\n")
    f.write('\n')
    f.write('}\n')


def create_module(module):

    # Install cache for 8x speedup
    requests_cache.install_cache()

    # Ascertain yang module's name
    yang_module_name = "iana-tls-" + module["hypenated_name"] + "-algs.yang"

    # Create yang module file
    with open(yang_module_name, "w") as f:
        create_module_begin(module, f)
        create_module_body(module, f)
        create_module_end(f)


def main():
    for module in MODULES:
        create_module(module)


if __name__ == "__main__":
    main()
