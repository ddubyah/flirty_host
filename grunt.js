'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package.json>',
    test: {
      files: ['test/**/*.js']
    },
    lint: {
      files: ['lib/**/*.js', 'test/**/*.coffee']
    },
    watch: {
      files: ['<config:coffee.app.src>', 'src/**/*.jade'],
      tasks: 'coffee:app'
    },
    coffee: {
      app: {
        src: ['src/**/*.coffee'],
        dest: './lib',
        options: {
          preserve_dirs: true,
          base_path: 'src'
        }
      },
      bin: {
        src: ['bin_src/**/*.coffee'],
        dest: './bin_src',
      }
    },
    coffeelint: {
      all: { 
        src: ['src/**/*.coffee', 'test/**/*.coffee'],
      }
    },
    exec: {
      compile_bin: {
        command: "( echo '#!/usr/bin/env node'; coffee -cp ./bin_src/flirt.coffee ) > ./bin/flirt.js"
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
  grunt.loadNpmTasks('grunt-exec');
  grunt.loadNpmTasks('grunt-clean');
};