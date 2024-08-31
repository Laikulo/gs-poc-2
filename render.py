#!/usr/bin/env python3

import configparser
import csv
from pathlib import Path
import shutil
import jinja2

conf_vars = {}

cp = configparser.ConfigParser()
cp.read('ghostship.conf')

for entry in cp['ghostship']:
    conf_vars[entry] = cp['ghostship'][entry]

def template_file(name: str, tpl_env, tpl_var):
    tpl = tpl_env.get_template(name + ".in")
    outpath = Path('confs') / name
    with outpath.open('w') as output_file:
        output_file.write(tpl.render(**tpl_var))
        output_file.truncate()

with open('printer-list', newline='') as printer_list_file:
    printer_rows = csv.DictReader(printer_list_file)
    conf_vars['printers'] = list(printer_rows)

jenv = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath="./templates/"))

template_file('Caddyfile',jenv,conf_vars)
template_file('dnsmasq-ghostship.conf',jenv,conf_vars)
template_file('caddy-fluidd-config.json.tpl',jenv,conf_vars)
template_file('caddy-mainsail-config.json.tpl',jenv,conf_vars)


tftp_base=Path('./tftproots')
pi_common_paths = [ Path('scratch') / 'pi-fw' / f for f in [
        'bootcode.bin',
        'fixup4cd.dat',
        'fixup4.dat',
        'fixup4db.dat',
        'fixup4x.dat',
        'fixup_cd.dat',
        'fixup.dat',
        'fixup_db.dat',
        'fixup_x.dat',
        'start4cd.elf',
        'start4db.elf',
        'start4.elf',
        'start4x.elf',
        'start_cd.elf',
        'start_db.elf',
        'start.elf',
        'start_x.elf'
    ]]

for printer in conf_vars['printers']:
    this_tftp = tftp_base / printer['ip_addr']
    if not this_tftp.exists():
        this_tftp.mkdir()
    if printer['nb_type']:
        if printer['nb_type'] in [ 'pi_3', 'pi_3p', 'pi_4', 'pi_5' ]:
            for p in pi_common_paths:
                shutil.copy(p, this_tftp / p.name)
        if printer['nb_type'] == 'pi_3':
            pass
        elif printer['nb_type'] == 'pi_3p':
            pass
        elif printer['nb_type'] == 'pi_4':
            pass
        elif printer['nb_type'] == 'pi_5':
            pass
        elif printer['nb_type'] == 'pxe_x64':
            pass
        elif printer['nb_type'] == 'pxe_lafrite':
            pass
        else:
            raise ValueError("Unknown netboot type")

    
