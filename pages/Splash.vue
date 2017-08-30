<template>
  <div class="row">
    <div class="col-md-12 logo-wrapper">
      <img class="logo" src="/public/logo.png">
    </div>
    <div class="col-md-6">
      <b-button size="lg">I Want</b-button>
    </div>
    <div class="col-md-6">
      <b-button size="lg">I Have</b-button>
    </div>
    <div class="col-md-8 offset-md-2 description">
     {{description}}
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        description: 'Articifial Intelligence that makes buying things not suck'
      }
    },

    name: 'splash',

    route: '/'
  }
</script>

<style lang="stylus" scoped>
  .description
    color white
    text-align center
    font-size x-large
    width 100%
    padding 35px

  .logo-wrapper
    text-align center

  .logo
    max-width 100%
    margin-bottom 35px
</style>
