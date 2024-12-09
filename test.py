import os
os.environ["XLA_PYTHON_CLIENT_PREALLOCATE"]="true"
import jax
import time
# from jax_utils import oneLineJaxRNG
import jax.numpy as jnp



class oneLineJaxRNG:
    def __init__(self, init_num=0) -> None:
        self.rng = jax.random.PRNGKey(init_num)
        
    def new_key(self):
        self.rng, key = jax.random.split(self.rng)
        return key
print(jax.devices())
gpu_device = jax.devices('gpu')[0]
cpu_device = jax.devices('cpu')[0]

def my_function(x):
  return x.sum()

my_function_cpu = jax.jit(my_function, device=cpu_device)
my_function_gpu = jax.jit(my_function, device=gpu_device)

x = jax.numpy.arange(100000000)

# gpu:0
x_gpu = my_function_gpu(x)
start_time = time.time()
x_gpu = my_function_gpu(x)
print(x_gpu.devices(), time.time() - start_time)

# TFRT_CPU_0
x_cpu = my_function_cpu(x)
start_time = time.time()
x_cpu = my_function_cpu(x)
print(x_cpu.devices(), time.time() - start_time)

jrng = oneLineJaxRNG()
n_steps = 8
reward = jax.random.normal(jrng.new_key(), shape=(16, n_steps))
accum_matrix = jnp.triu(jnp.ones((n_steps, n_steps)))
def returns(r):
    # r: [n_steps]
    return jnp.dot(accum_matrix, r)  # R: [n_steps]
print('accum_matrix', accum_matrix)
print('hi')
R = jax.vmap(returns)(reward)
print(R)