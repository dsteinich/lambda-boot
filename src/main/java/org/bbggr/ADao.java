package org.bbggr;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class ADao {

	@Autowired
	protected JdbcTemplate jdbcTemplate;

	public int getRecordCount() {
		return jdbcTemplate.queryForObject("select count(*) from json_data", Integer.class);
	}

}
