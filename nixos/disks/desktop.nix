{
  enableConfig = false;
  devices.disk = {
    main = {
      type = "disk";
      device = "/dev/by-uuid/04E70B56-6A9F-48C8-8832-49E3D05F426D";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            size = "100M";
            type = "EF00";
            content = {
              format = "vfat";
              type = "filesystem";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              format = "ext4";
              type = "filesystem";
              mountpoint = "/";
            };
          };
        };
      };
    };
    ssd = {
      type = "disk";
      device = "/dev/by-uuid/4DE0E702-6352-4591-8EFF-D9F92B4369E0";
      content = {
        type = "gpt";
        partitions = {
          root = {
            size = "100%";
            content = {
              format = "ext4";
              type = "filesystem";
              mountpoint = "/mnt/proyectos";
            };
          };
        };
      };
    };
  };
}
