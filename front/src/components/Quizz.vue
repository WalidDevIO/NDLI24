<template>
    <Loader v-model="loading"/>
    <VContainer class="d-flex justify-center align-center">
        <VCard v-if="quizz && !end">
            <VCardTitle class="break-text">
                {{ actual.question }}
            </VCardTitle>
            <VCardText>
                <VRadioGroup v-model="checked" row>
                    <VRadio
                        v-for="(res, index) in actual.answers"
                        :key="index"
                        :label="res.text"
                        :value="res.text"
                    />
                </VRadioGroup>
                <VCardActions>
                    <VRow>
                        <VCol class="d-flex justify-center align-center">Question {{ questionIndex+1 }}/{{ quizz.length }}</VCol>
                        <VCol class="d-flex justify-center align-center">Score: {{ score }}</VCol>
                    </VRow>
                </VCardActions>
            </VCardText>
        </VCard>
        <VCard v-if="end">
            <VCardTitle>
                {{ endMessage }}
            </VCardTitle>
        </VCard>
        <template v-if="error">
            Une erreure est survenue.
        </template>
    </VContainer>
</template>

<script setup>
import { onMounted, ref, computed, watch } from 'vue';
import Loader from '@/components/Loader.vue';

const props = defineProps({
    name: {
        type: String,
        required: true
    }
})

const data = ref()
const error = ref(false)
const loading = ref(true)
const questionIndex = ref(0)
const checked = ref()
const score = ref(0)
const endMessage = computed(() => `Votre score est de ${score.value}/${quizz.value.length}.`)
const quizz = computed(() => data.value?.quizz)
const end = computed(() => quizz.value?.length == questionIndex.value)
const actual = computed(() => quizz.value[questionIndex.value])

onMounted(async () => {
    fetch(`/index.php?route=api/quizz/${props.name}`)
        .then(r => r.json())
        .then(d => data.value = d)
        .catch(() => error.value = true)
        .finally(() => loading.value = false)
})

watch(checked, (txt) => {
    if(actual.value.answers.find(a => a.text === txt).correct) {
        score.value++
    }
    questionIndex.value++
})
</script>

<style scoped>
* {
    color: white;
}

.break-text {
  word-wrap: break-word !important;
  word-break: break-word !important;
  overflow-wrap: break-word !important;
  white-space: normal !important;
}
</style>