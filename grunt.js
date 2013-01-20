'use strict';
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package.json>',
    test: {
      files: ['test/**/*.js']
    },
    lint: {
      files: ['grunt.js', 'lib/**/*.js', 'test/**/*.js']
    },
    watch: {
      files: ['<config:lint.files>', '<config:coffee.app.src>'],
      tasks: 'coffee default'
    },
    coffee: {
      app: {
        src: ['src/**/*.coffee'],
        dest: './',
        options: {
          preserve_dirs: true,
          base_path: 'src'
        }
      }
    },
    coffeelint: {
      all: { 
        src: ['src/**/*.coffee', 'test/**/*.coffee'],
      }
    },
    clean:{
      folder: 'lib'
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        boss: true,
        eqnull: true,
        node: true
      },
      globals: {
        exports: true
      }
    }
  });

  // Default task.
  grunt.registerTask('default', 'coffeelint coffee');
  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-clean');
};