import multiprocessing.pool as mpp
import subprocess
import sys

POTRACE = sys.argv[1]


def worker(i):
    bmp = f"../02_Extract_Frames/bmps/{i}.bmp"
    svg = f"svgs/{i}.svg"
    print(f"Processing {i}.bmp...")
    subprocess.Popen([POTRACE, "-s", bmp, "-o", svg]).wait()


mpp.Pool().map(worker, range(1, 6573 + 1))
