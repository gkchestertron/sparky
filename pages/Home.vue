<template>
  <div class="row">
    <jumbo-tron :title="title"></jumbo-tron>
    <card 
       :title="welcome.title"
       :text="welcome.text"
       size="8"
       :idx="0"
     ></card>
    <card 
       :title="announcements.title"
       :text="announcements.text"
       size="4"
       :idx="1"
     ></card>
    <contact-card></contact-card>
  </div>  
</template>

<script>
  export default {
    data() {
      return {
        title: 'Home',
        body: 'here have some text',
        welcome: { title: 'welcome', text: 'welcome text' },
        announcements: { title: 'Announcements', text: 'announcements text' }
      }
    },

    name: 'home',

    route: '/'
  }
</script>
