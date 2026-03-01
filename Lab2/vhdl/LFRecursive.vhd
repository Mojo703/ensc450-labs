library ieee;
use ieee.std_logic_1164.all;

entity LFRecursive is
  generic (N : natural := 4);
  port (
    Gen, Prop           : in std_logic_vector(N - 1 downto 0);
    blockGen, blockProp : out std_logic_vector(N - 1 downto 0)
  );
end entity;

architecture behavioral of LFRecursive is
  component Merger is
    -- Combines the upper and lower block signals into one block signal
    port (
      GLow, PLow, GHi, PHi : in std_logic;
      Gout, Pout           : out std_logic
    );
  end component;
  signal TopGenOutputs  : std_logic_vector(N / 2 - 1 downto 0);
  signal TopPropOutputs : std_logic_vector(N / 2 - 1 downto 0);
  signal BotGenOutputs  : std_logic_vector(N / 2 - 1 downto 0);
  signal BotPropOutputs : std_logic_vector(N / 2 - 1 downto 0);

  signal TopGenInputs  : std_logic_vector(N / 2 - 1 downto 0);
  signal TopPropInputs : std_logic_vector(N / 2 - 1 downto 0);
  signal BotGeninputs  : std_logic_vector(N / 2 - 1 downto 0);
  signal BotPropInputs : std_logic_vector(N / 2 - 1 downto 0);

  signal MergerGenOutputs  : std_logic_vector(N / 2 - 1 downto 0);
  signal MergerPropOutputs : std_logic_vector(N / 2 - 1 downto 0);

begin
  -- Case for N=2
  gen0 : if N = 2 generate
    merging2 : Merger
    port map
    (
      GLow => Gen(0),
      PLow => Prop(0),
      GHi  => Gen(1),
      PHi  => Prop(1),
      Gout => BlockGen(1),
      Pout => BlockProp(1)
    );
    BlockGen(0)  <= Gen(0);
    BlockProp(0) <= Prop(0);
  end generate;

  gen2 : if N > 2 generate
    TopGenInputs  <= Gen(N - 1 downto N / 2);
    TopPropInputs <= Prop(N - 1 downto N / 2);
    BotGenInputs  <= Gen(N / 2 - 1 downto 0);
    BotPropInputs <= Prop(N / 2 - 1 downto 0);

    top_recursive : entity work.LFRecursive
      generic map(N => N / 2)
      port map
      (
        Gen       => TopGenInputs,
        Prop      => TopPropInputs,
        blockGen  => TopGenOutputs,
        blockProp => TopPropOutputs
      );

    bottom_recursive : entity work.LFRecursive
      generic map(N => N / 2)
      port map
      (
        Gen       => BotGenInputs,
        Prop      => BotPropInputs,
        blockGen  => BotGenOutputs,
        blockProp => BotPropOutputs
      );
    generateMerge : for i in N / 2 - 1 downto 0 generate
      merging : Merger
      port map
      (
        GLow => BotGenOutputs(N / 2 - 1),
        PLow => BotPropOutputs(N / 2 - 1),
        GHi  => TopGenOutputs(i),
        PHi  => TopPropOutputs(i),
        Gout => MergerGenOutputs(i),
        Pout => MergerPropOutputs(i)
      );
    end generate;
    blockGen  <= MergerGenOutputs & BotGenOutputs;
    blockProp <= MergerPropOutputs & BotPropOutputs;
  end generate;
end architecture;
