pkgs:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
in
{
  bookmarks = { };
  extensions = with addons; [ ublock-origin ];

  userChrome = '''';
  userContent = '''';

  search = {
    force = true;
    default = "Google";
    engines = {
      "Bing".metaData.hidden = true;
      "Google".metaData.alias = "@g";
      "Nix Packages" = {
        definedAliases = [ "@np" ];
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "channel";
                value = "unstable";
              }
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
    };
  };
}
