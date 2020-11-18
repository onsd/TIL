class Era
    # 元号変換ロジック
    #
    # @param year [Integer] 西暦
    # @param month [Integer] 月(1〜12)
    # @param day [Integer] 日(1〜31)
    # @return [String] 元号変換後の文字列 ex) "平成10年"
    def calc(year, month, day)
        # TODO: 元号変換ロジックを書く
        # 昭和 1926/12/25 ~ 1989/1/7
        # 平成 1989/1/8 ~ 2019/4/30
        # 令和 2019/5/1 ~

        inputTime = Time.new(year, month, day)
        
        if Time.new(1926, 12, 25) <= inputTime && inputTime <= Time.new(1989, 1, 7)
            # 昭和
            "昭和#{year - 1925 == 1? "元": year - 1925}年"
        elsif Time.new(1989, 1, 8) <= inputTime && inputTime <= Time.new(2019, 4, 30)
            # 平成
            "平成#{year - 1988 == 1 ? "元" : year - 1988}年"
        elsif Time.new(2019, 5, 1) <= inputTime
            # 令和
            "令和#{year-2018==1 ? "元" : year-2018}年"
        else
            # 過去
            raise ArgumentError
        end
    end
end