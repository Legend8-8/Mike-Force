// Minimal test: single MiG-21 group for Zeus Reinforcements

class CfgGroups {
    class East {
        class O_PAVN {
            class Air {
                class BN_ZEUS_MiG21_CAP {
                    name    = "MiG-21 CAP (Zeus)";
                    side    = 0;
                    faction = "O_PAVN";
                    icon    = "\A3\ui_f\data\map\markers\nato\o_plane.paa";
                    class Unit0 {
                        side      = 0;
                        vehicle   = "vn_o_air_mig21_cap";
                        rank      = "LIEUTENANT";
                        position[] = {0,0,0};
                    };
                };
            };
        };
    };
};
