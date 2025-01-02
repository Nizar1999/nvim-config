return {
  -- CMake Tools plugin
  {
    'Civitasv/cmake-tools.nvim',
    config = function()
      -- General setup for cmake-tools.nvim
      require('cmake-tools').setup({
        cmake_command = "cmake",  -- Define the cmake command
        build_directory = "build",  -- Specify the build directory
        configure_args = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=YES" },  -- Optional configure args
      })
    end
  }
}
