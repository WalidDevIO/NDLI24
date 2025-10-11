<template>
  <div 
    v-if="visible" 
    :style="computedStyle"
    class="logo"
    @mouseover="moveLogo"
    @click="handleClick"
  >
    <img :src="logo" alt="Logo" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import logo from '@/assets/logo.jpg';

const pos = ref({ top: 0, left: 0 });
const visible = ref(false);
const rotation = ref(0);

const loop = async () => {
  visible.value = true;
  randomPos();

  await new Promise(resolve => setTimeout(resolve, 2000));
  visible.value = false;

  await new Promise(resolve => setTimeout(resolve, 5000));
  loop();
};

const randomPos = () => {
  const viewportWidth = window.innerWidth;
  const viewportHeight = window.innerHeight;

  pos.value.top = Math.random() * (viewportHeight - 100);
  pos.value.left = Math.random() * (viewportWidth - 100);
  rotation.value = Math.random() * 360;
};

const moveLogo = () => {
  const direction = Math.random() < 0.5 ? -1 : 1;
  pos.value.left += direction * 20;
};

const handleClick = (event) => {
    const bodyStyle = document.body.style;
    bodyStyle.backgroundImage = "url('/dist/logo.jpg')";
    bodyStyle.backgroundSize = 'contain';
    document.body.classList.add('rotating-background');
    setTimeout(() => {
        bodyStyle.backgroundImage = null
        bodyStyle.backgroundSize = null
        document.body.classList.remove('rotating-background')
    }, 3000)
};

const computedStyle = computed(() => ({
  top: `${pos.value.top}px`,
  left: `${pos.value.left}px`,
  position: 'absolute',
  zIndex: 1000,
  transform: `rotate(${rotation.value}deg)`,
  transition: 'all 0.3s ease',
}));

onMounted(() => {
  loop();
});
</script>

<style scoped>
.logo img {
  width: 75px;
  border-radius: 25px;
  cursor: pointer;
}

.click-area {
  width: 100vw;
  height: 100vh;
  background-color: #1c1c1c;
  position: relative;
  overflow: hidden;
  cursor: pointer;
}
</style>