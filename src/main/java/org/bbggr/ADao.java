package org.bbggr;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ADao extends SqlSessionDaoSupport {

	@Autowired
	public ADao(SqlSessionFactory sqlSessionFactory) {
		setSqlSessionFactory(sqlSessionFactory);
	}

	public int getRecordCount() {
		return getSqlSession().selectOne("one");
	}

}
