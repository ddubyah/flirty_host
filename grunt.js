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
      files: ['<config:coffee.app.src>', 'src/**/*.jade'],
      tasks: 'coffee cp'
    },
    coffee: {
      app: {
        src: ['src/lib/**/*.coffee'],
        dest: './lib',
        options: {
          preserve_dirs: true,
          base_path: 'src/lib'
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
    cp: {
      dist: {
        src: 'src/lib/flirty/views',
        dest: 'lib/flirty/views'
      }
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
  grunt.registerTask('default', 'coffeelint coffee cp');
  grunt.loadNpmTasks('grunt-coffee');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-cp');
  grunt.loadNpmTasks('grunt-clean');
};