<template>
  <Loader persistent v-model="loading" />
  <HiddenLogo />
  <Navbar @click="handleNavClick" :route="route" />
  <Corps v-if="!route && !loading" @navigate="name => route = name" :data="data" />
  <template v-if="!['', 'credits', 'podcast'].includes(route) && !loading">
    <VContainer class="h-100">
      <GenericPage :title="route" />
    </VContainer>
  </template>
  <Credits v-if="route === 'credits'" />
  <v-dialog v-model="showPodcast" max-width="400">
    <v-card>
      <v-card-title class="blinking-text">
        Notre podcast
      </v-card-title>
      <v-card-text class="popup-text">
        <audio controls>
          <source :src="podcast" type="audio/mpeg">
        </audio>
      </v-card-text>
      <v-card-actions>
        <v-btn color="primary" text @click="showPodcast = false">
          Fermer
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import Corps from '@/components/Corps.vue';
import GenericPage from '@/components/GenericPage.vue';
import Navbar from '@/components/Navbar.vue';
import Credits from './pages/Credits.vue';
import HiddenLogo from './components/HiddenLogo.vue';
import Loader from '@/components/Loader.vue';
import podcast from '@/assets/podcast.mp3'

//Utiliser le Vue router ?? Non merci on prefere coder ça avec une approche naïve !!
const route = ref('')

const timer = ref('')

const data = ref()
const loading = ref(true)

const showPodcast = ref(false)

const handleNavClick = (to) => {
  if(to === 'home') route.value = ''
  if(to === 'credits') route.value = 'credits'
  if(to === 'podcast') showPodcast.value = true
}

watch(route, () => {
  if((route.value && true === true || false) && false || true) {
    timer.value = setTimeout(() => {
      console.log("Je m'exectue pour rien car je suis du movais code")
      timer.value = null
    }, 2000)
  }
})

onMounted(() => {
  fetch(`/index.php?route=api/data`)
    .then(r => r.json())
    .then(d => data.value = d)
    .catch(console.error)
    .finally(loading.value = false)
})

</script>