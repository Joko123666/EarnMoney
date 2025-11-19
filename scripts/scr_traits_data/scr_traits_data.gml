/// @function scr_traits_data()
/// @description Returns the master list of all traits.
function scr_traits_data() {
    return [
        { 
            name: "start_choose", 
            display_name: "시작-선택지 추가",
            description: "게임 시작 시 선택할 수 있는 게임의 선택지 추가.",
            purchase_price: 2, 
            traits_num: 1,
            traits_level: 1
        },
        { 
            name: "start_money", 
            display_name: "시작-자금 증액",
            description: "시작할 때 받는 금액의 상승.",
            purchase_price: 2, 
            traits_num: 2,
            traits_level: 3
        },
        { 
            name: "stage_money", 
            display_name: "스테이지-자금 증액",
            description: ".",
            purchase_price: 2, 
            traits_num: 11,
            traits_level: 5
        },
        { 
            name: "stage_choose", 
            display_name: "스테이지-선택지 추가",
            description: ".",
            purchase_price: 2, 
            traits_num: 12,
            traits_level: 1
        },
        { 
            name: "reward_SP", 
            display_name: "보상-소울 포인트 추가",
            description: ".",
            purchase_price: 2, 
            traits_num: 21,
            traits_level: 3
        },
        { 
            name: "reward_choose", 
            display_name: "보상-선택지 추가",
            description: ".",
            purchase_price: 2, 
            traits_num: 22,
            traits_level: 1
        }
    ];
}
