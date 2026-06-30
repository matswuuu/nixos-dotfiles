#!/usr/bin/env bash

first_names=(
Akari Aoi Akane Ami Ayaka Ayane Chihiro Emi Eri Fumika
Hina Hinata Haruka Hana Hikari Honoka Ichika Izumi Jun Kaede
Kana Kanon Karin Kasumi Kayo Keiko Kanna Koharu Kokoro Kotone
Madoka Mai Maki Mao Mari Mayu Mei Miku Mina Minori
Misaki Mio Miyu Momoka Nagisa Nana Nanami Natsuki Nozomi Riko
Rin Rio Rina Risa Rui Sakura Saki Sayaka Shiori Shizuku
Suzune Sumire Tomomi Tsukasa Tsubaki Yui Yuka Yuki Yumiko Yuna
Yuri Yuuna Airi Asuka Chika Haruna Himari Kaho Kirari Misuzu
Mizuki Nao Reika Reina Remi Rumi Sana Serina Shina Tamaki
Wakana Yuzuki Ayumi Hotaru Kazumi Miho Nene Ruriko Saori Yukari
)

last_names=(
Sato Suzuki Takahashi Tanaka Watanabe Ito Yamamoto Nakamura Kobayashi Kato
Yoshida Yamada Sasaki Yamaguchi Matsumoto Inoue Kimura Hayashi Shimizu Saito
Yamazaki Mori Abe Ikeda Hashimoto Ishikawa Nakajima Maeda Fujita Ogawa
Goto Okada Hasegawa Murakami Kondo Ishii Sakamoto Endo Aoki Fujii
Nishimura Fukuda Ota Miura Takeuchi Nakagawa Matsuda Harada Ueda Nakano
Hara Ono Tamura Takagi Ando Fujimoto Okamoto Nakamichi Kaneko Wada
Nakayama Ishida Morita Ueno Sugiyama Chiba Iwasaki Araki Miyazaki Kudo
Nomura Kojima Shibata Oishi Hirano Kinoshita Takeda Uehara Nishida Kurata
Sakurai Furukawa Matsui Tsuchiya Nakata Morimoto Yokoyama Hirata Kawai Noda
Shinohara Tani Oshima Hoshino Kuroda Kawamura Tsuji Hirayama Miyamoto Kitagawa
)


first=${first_names[RANDOM % ${#first_names[@]}]}
last=${last_names[RANDOM % ${#last_names[@]}]}

echo "$first $last"
