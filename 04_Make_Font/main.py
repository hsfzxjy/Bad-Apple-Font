import random
import multiprocessing as mp
import multiprocessing.pool as mpp
import subprocess
import sys
import os


def chunk_list(input_list, n):
    avg_chunk_size = len(input_list) // n
    remainder = len(input_list) % n

    chunks = []
    start = 0
    for i in range(n):
        chunk_size = avg_chunk_size + (1 if i < remainder else 0)
        end = start + chunk_size
        chunks.append(input_list[start:end])
        start = end

    return chunks


input_sfd_filename = sys.argv[1]
output_sfd_filename = sys.argv[2]


def worker(i, chunk, output_filename):
    subprocess.Popen(
        [
            "./fontforge",
            "-lang=py",
            "-script",
            os.path.join(os.getcwd(), "import_svg.py"),
            input_sfd_filename,
            output_filename,
            *chunk,
        ]
    ).wait()


random.seed(42)
files = sys.argv[3:]
random.shuffle(files)
njobs = mp.cpu_count() - 1
chunks = chunk_list(files, njobs)
p = mpp.Pool(njobs)
output_files = []
for i, chunk in enumerate(chunks):
    output = output_sfd_filename.replace("generated", f"generated_{i}")
    output_files.append(output)
    p.apply_async(worker, (i, chunk, output))
p.close()
p.join()

subprocess.Popen(
    [
        "./fontforge",
        "-lang=py",
        "-script",
        os.path.join(os.getcwd(), "merge.py"),
        input_sfd_filename,
        output_sfd_filename,
        *output_files,
    ]
).wait()
