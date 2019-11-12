INSERT INTO `cyberrange`.`geni_output`
(`slice_name`,
`output`,
`status`,
`user_id`,
`module_id`,
`sh_name`)
VALUES
(@slice_name,
@output,
@status,
@user_id,
@module_id,
@sh_name);
