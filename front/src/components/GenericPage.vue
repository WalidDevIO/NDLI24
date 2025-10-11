<template>
    <Loader v-model="loading" persistent/>
    <VContainer class="d-flex justify-center align-center">
        <VCard style="width: 75vw !important;">
            <VCardTitle>
                {{ title.charAt(0).toUpperCase() + title.slice(1) }}
            </VCardTitle>
            <VCardText>
                <p>{{ text }}</p>
            </VCardText>
        </VCard>
    </VContainer>
    <Quizz :name="props.title" />
</template>

<script setup>
import { onMounted, ref } from 'vue';
import Loader from './Loader.vue';
import Quizz from './Quizz.vue';

const loading = ref(true)
const text = ref("")
const error = ref(false)
const data = ref()

const props = defineProps({
    title: {
        type: String,
        required: true
    }
})

const launchFetching = (part) => {
    fetch(`/index.php?route=api/contenu/${props.title}/${part}`)
        .then(r => r.json())
        .then(d => data.value = d)
        .catch(() => error.value = true)
        .finally(() => {
            if(!error.value) {
                if(data.value.nextPart) {
                    setTimeout(() => launchFetching(data.value.nextPart), 260)
                    text.value = text.value + data.value.text
                    return;
                }
                text.value = text.value + data.value.text
            }
            loading.value = false
        })
}

onMounted(() => {
    launchFetching(0)
})

</script>

<style scoped>
p {
    color: white;
}
</style>